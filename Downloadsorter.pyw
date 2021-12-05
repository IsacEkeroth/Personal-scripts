import os
from shutil import move

download_path = "D:/Hamtade filer/"

os.chdir(download_path)

files = os.listdir(download_path)

types = {
    "zip": [".zip", ".rar", ".7z", ".gz", ".tar", ".bz2"],
    "video": [".mp4", ".mov", ".m4v", ".flv", ".webm", ".mkv"],
    "pictures": [".jpeg", ".jfif", ".jpg", ".png", ".gif", ".webp", ".ico", ".svg", ".PNG", ".JPG"],
    "text": [".txt", ".cfg", ".ini", ".pdf", ".docx", ".doc"],
    "program": [".exe", ".dll", ".js", ".py", ".ahk", ".jar", ".sh", ".bat", ".html", ".css", ".lua", ".sql", ".msi", ".cpp", ".h", ".c", ".hpp", ".pro", "br", ".lol"],
    "audio": [".aac", ".mp3", ".wav", ".m4a", ".mka", ".ogg"]
}

for file in files:
    if os.path.isdir(download_path + file):
        continue
    ext = os.path.splitext(file)[1]
    try:
        sort = list(types.keys())[
            list(ext in i for i in types.values()).index(True)]
    except ValueError:
        sort = "misc"
    try:
        move(file, download_path + sort)
    except Exception:
        pass
