# file_mappings.py

images = {
    "jpg",
    "jpeg",
    "png",
    "gif",
    "bmp",
}

videos = {
    "mp4",
    "avi",
    "mov",
    "mkv",
}

documents = {
    "txt",
    "pdf",
    "doc",
    "docx",
}

apps = {
    "exe",
    "bat",
    "msi",
    "sh",
}

archives = {
    "zip",
    "rar",
    "tar",
    "gz",
    "7z",
}

code = {
    "py",
    "js",
    "java",
    "c",
    "cpp",
    "html",
    "css",
    "rb",
    "php",
}

# Combine all mappings into one dictionary
file_mappings = {
    **{ext: "Images" for ext in images},
    **{ext: "Videos" for ext in videos},
    **{ext: "Documents" for ext in documents},
    **{ext: "Apps" for ext in apps},
    **{ext: "Archives" for ext in archives},
    **{ext: "Code" for ext in code},
}

