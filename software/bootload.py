import serial
import time
import os

def create_packet(address: int, data: int) -> bytes:
    """Constructs a 9-byte packet based on the 24-bit address and 32-bit data."""
    start_byte = 0xAB #[cite: 1]
    
    # Extract address bytes (24-bit)
    addr_h = (address >> 16) & 0xFF
    addr_m = (address >> 8) & 0xFF
    addr_l = address & 0xFF
    
    # Extract data bytes (32-bit)
    data_3 = (data >> 24) & 0xFF
    data_2 = (data >> 16) & 0xFF
    data_1 = (data >> 8) & 0xFF
    data_0 = data & 0xFF
    
    # Calculate checksum (XOR of bytes 1-7)[cite: 1]
    checksum = addr_h ^ addr_m ^ addr_l ^ data_3 ^ data_2 ^ data_1 ^ data_0
    
    # Construct the final packet
    return bytes([
        start_byte, 
        addr_h, addr_m, addr_l, 
        data_3, data_2, data_1, data_0, 
        checksum
    ])

def main():
    # Configuration
    port = 'COM5'
    baudrate = 2000000  # Matches Verilog receiver configuration[cite: 2]
    bin_file_path = 'main.bin' # Replace with your actual .bin file name
    
    # Starting base address in memory (e.g., 0x000000)
    base_address = 0x000000  
    
    if not os.path.exists(bin_file_path):
        print(f"Error: Binary file '{bin_file_path}' not found.")
        return

    try:
        ser = serial.Serial(port, baudrate, timeout=1)
        time.sleep(2) # Wait for connection to stabilize
        print(f"Connected to {port} at {baudrate} baud.")
    except serial.SerialException as e:
        print(f"Error opening serial port: {e}")
        return

    file_size = os.path.getsize(bin_file_path)
    print(f"Sending '{bin_file_path}' ({file_size} bytes)...")

    # Read and send file in 4-byte increments (32-bit data chunks)
    current_address = base_address
    packets_sent = 0

    with open(bin_file_path, 'rb') as f:
        while True:
            chunk = f.read(4) # Read 4 bytes of data at a time
            if not chunk:
                break
            
            # If the file size isn't a multiple of 4, pad the last chunk with zeros
            if len(chunk) < 4:
                chunk = chunk.ljust(4, b'\x00')
            
            # Convert 4 bytes to a 32-bit integer (little-endian or big-endian based on your system)
            # int.from_bytes(..., 'little') is standard for most binary toolchains (like RISC-V/ARM)
            data_val = int.from_bytes(chunk, byteorder='little')

            print(f"instr {current_address * 4}: {data_val:08X}")
            # print(f"32'h{data_val:08X},")

            # Create packet
            packet = create_packet(current_address, data_val)
            
            # Send packet over UART
            #print(f"Sending packet: {packet.hex(' ')}")
            ser.write(packet)
            packets_sent += 1
            
            # Increment address by 4 bytes for the next 32-bit word
            current_address += 1
            
            # Optional: Add a very small delay if the FPGA buffer needs breathing room
            # time.sleep(0.0001)

    # Send 5 packets with instruction "jal ." so that program counter repeats itself upon completion.
    for i  in range(5):
        packet = create_packet(current_address, 0x0000006F)
        ser.write(packet)
        packets_sent += 1
        current_address += 1

    print(f"Total packets sent: {packets_sent}")

    # Send 5 no ops
    for i in range(5):
        packet = create_packet(current_address, 0x00000000)
        ser.write(packet)
        packets_sent += 1
        current_address += 1

    # --- End the Bit Stream ---
    # Send the finish byte expected by the Verilog state machine[cite: 1]
    finish_byte = bytes([0xEF])
    ser.write(finish_byte)
    print("Sent finish byte (0xEF). Transmission complete.")

    ser.close()

if __name__ == "__main__":
    main()