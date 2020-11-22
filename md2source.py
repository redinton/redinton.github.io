 # -*- coding: utf-8 -*
import os
import time
import json
import shutil
from datetime import datetime

markdown_folders = [
    "md/develop/MQ",
    "md/develop/mysql",
    "md/develop/linux",
    "md/algorithm",
    "md/develop/systemDesign",
    "md/learn/操作系统",
    "md/learn/网络",
    "md/language/python"
    ]
hexo_des_folder = "source/_posts/"
time_checkpoint = "last_update_time.txt"

def datetime2str(time):
    return time.strftime('%Y-%m-%d %H:%M:%S')

currTime = datetime2str(datetime.now())
with open(time_checkpoint,"r",encoding="utf-8") as f:
    last_modified_time = json.load(f)

def getFileAccessTime(filePath):
    t = os.path.getatime(filePath)
    return datetime2str(TimeStampToTime(t))

def TimeStampToTime(timestamp):
    timeStruct = time.localtime(timestamp)
    return datetime.strptime(time.strftime('%Y-%m-%d %H:%M:%S',timeStruct),'%Y-%m-%d %H:%M:%S')

def copyFolder(src,dst):
    folder_name = src.split("/")[-1]
    dst = os.path.join(dst,folder_name)
    if os.path.exists(dst):
        shutil.rmtree(dst)
    shutil.copytree(src,dst)
    

def main(markdown_folder):
    for root,dirs,files in os.walk(markdown_folder):
        for fileName in files:
            if fileName.endswith("md"):
                file_path = os.path.join(root,fileName)

                if fileName not in last_modified_time or getFileAccessTime(file_path) > last_modified_time[fileName]:
                    shutil.copy(file_path,hexo_des_folder)
                    last_modified_time[fileName] = currTime
                
        for dir_name in dirs:
            dirPath = f"{root}/{dir_name}" #os.path.join(root,dir_name)
            if dirPath not in last_modified_time or getFileAccessTime(dirPath) > last_modified_time[dirPath]:
                copyFolder(dirPath,hexo_des_folder)
                last_modified_time[dirPath] = currTime

    with open(time_checkpoint,"w",encoding="utf-8") as f:
        json.dump(last_modified_time,f,ensure_ascii=False,indent=4)
        # f.writelines(datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
    

def add_prefix_md(fileName:str,tags:list) -> list:
    line0 = "---\n"
    line1 = f"title: {fileName}\n"
    line2 = f"date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n"
    line3 = "tags:\n"
    lines = [line0,line1,line2,line3]
    for tag in tags:
        line = f"- {tag}\n"
        lines.append(line)
    line4 = "toc: true\n"
    line5 = "---\n"
    lines.append(line4 + line5)

    return lines


if __name__ == "__main__":
    for markdown_folder in markdown_folders:
        main(markdown_folder)
    
    # shutil.copy(os.path.join("md\\nlp","BERT.md"),hexo_des_folder)

    # with open(os.path.join("md\\nlp","BERT.md"),encoding="utf-8") as f:
    #     lines = f.readlines()
    #     pre_lines = add_prefix_md("BERT.md",["nlp"])
    #     print (pre_lines)
        # merge_md = pre_lines + lines
        # with open("tets.md",mode="w+",encoding="utf-8") as f1:
        #     f1.writelines(merge_md)
        # for line in lines:
        #     print (line)
    

