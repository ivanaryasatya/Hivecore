import time
import sys


def data_type_converter(conversion_typeX, conversion_typeY, data):
    
    if conversion_typeX == "char":
        if conversion_typeY == "hex":
            return "0x" + hex(ord(data))[2:]
        elif conversion_typeY == "bin":
            ascii = ord(data)
            return format(ascii, '08b')
        elif conversion_typeY == "dec":
            return ord(data)
    elif conversion_typeX == "bin":
        if conversion_typeY == "hex":
            desimal = int(data, 2)   # biner ke desimal
            return hex(desimal)
        elif conversion_typeY == "char":
            desimal = int(data, 2)
            return chr(desimal)
        elif conversion_typeY == "dec":
            return int(data, 2)
    elif conversion_typeX == "hex":
        if conversion_typeY == "char":
            desimal = int(data, 16)
            return(chr(desimal))
        elif conversion_typeY == "bin":
            desimal = int(data, 16)
            return format(desimal, '08b')
        elif conversion_typeY == "dec":
            if data.startswith("0x") or data.startswith("0X"):
                data = data[2:]
            return int(data, 16)
    elif conversion_typeX == "dec":
        intData = int(data)
        if intData < 0 or intData > 255:
            return "Data keluar dari rentang (0-255)"
        if conversion_typeY == "char":
            return chr(intData)
        elif conversion_typeY == "hex":
            return hex(intData)
        elif conversion_typeY == "bin":
            return format(intData, '08b')
    return "Invalid conversion types or data"




if __name__ == '__main__':

    kata = ["██╗██╗░░░██╗░█████╗░███╗░░██╗",
            "██║██║░░░██║██╔══██╗████╗░██║",
            "██║╚██╗░██╔╝███████║██╔██╗██║",
            "██║░╚████╔╝░██╔══██║██║╚████║",
            "██║░░╚██╔╝░░██║░░██║██║░╚███║",
            "╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚══╝"
            ]

    for i in range(5):
        print(kata[i])
        time.sleep(0.5)
    
    while True:
        print(
            "\nHivecore Home Automation - Tool \n"
            "1. konversi tipe data\n"
        )
        # variabel array untuk menyimpan pilihan user
        userInputArray = ["0", "0", "0", "0", "0", "0"]

        userInput = input("Input > ")
        if userInput == "1":
            userInputArray[0] = input("Masukkan tipe data awal (char, bin, hex, dec): ")
            userInputArray[1] = input("Masukkan tipe data yang diinginkan (char, bin, hex, dec): ")
            userInputArray[2] = input("Masukkan data: ")
            print(f"Hasil konversi: {data_type_converter(userInputArray[0], userInputArray[1], userInputArray[2])}")
        elif userInput == "2":
            print("empty code")
        else:
            print("Pilihan tidak valid.")
    
