import os

def list_files(directory, file_handle):
    for root, dirs, files in os.walk(directory):
        for file in files:
            file_handle.write(os.path.join(root, file) + "\n")

if __name__ == "__main__":
    lib_path = r"c:\Users\fquaa\dev\TrackYourDrugs\lib"
    output_file = r"c:\Users\fquaa\dev\TrackYourDrugs\scripts\my_text_file.txt"
    with open(output_file, "w") as f:
        list_files(lib_path, f)