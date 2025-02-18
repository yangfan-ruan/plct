import os
import re
import shutil
import logging

# 配置日志
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def main():
    # 存放Markdown中引用的图片路径
    pictures_in_markdown = set()

    # 获取Markdown文件路径
    path = input("请输入Markdown文件的路径：").strip()
    # 获取图片的相对存储路径
    img_path = input("请输入图片的相对存储路径，例如：img、image、assets：").strip()

    # 遍历指定路径下的所有文件
    for root, _, files in os.walk(path):
        for file in files:
            file_path = os.path.join(root, file)
            # 判断是否为Markdown文件
            if file_path.endswith('.md'):
                with open(file_path, 'r', encoding='utf-8') as md_file:
                    content = md_file.read()
                    # 正则表达式匹配Markdown文件中所有图片的引用
                    pattern = re.compile(r'!\[(.*?)]\((.*?)\)|<img[^>]*?src="(.*?)"[^>]*?>')
                    matches = pattern.findall(content)
                    for match in matches:
                        ref = match[1] or match[2] or match[3]
                        # 获取图片名称
                        begin_index = ref.find(img_path) + len(img_path) + 1
                        # 将图片路径添加到集合中
                        picture = ref[begin_index:]
                        pictures_in_markdown.add(picture)

    # 获取指定目录中的所有图片
    pictures_in_directory = []
    for root, _, files in os.walk(os.path.join(path, img_path)):
        for file in files:
            pictures_in_directory.append(file)

    # 创建存放多余图片的目录
    redundant_dir = os.path.join(path, "RedundantImg")
    if len(pictures_in_directory) - len(pictures_in_markdown) != 0:
        os.makedirs(redundant_dir, exist_ok=True)

    # 查找多余的图片
    redundant_images = [img_file for img_file in pictures_in_directory if img_file not in pictures_in_markdown]

    # 将多余的图片移动到指定的目录
    for img_file in redundant_images:
        img_path_src = os.path.join(path, img_path, img_file)
        img_path_dst = os.path.join(redundant_dir, img_file)
        logger.info(f"移动冗余图片: {img_file}")
        shutil.move(img_path_src, img_path_dst)

    # 输出结果信息
    logger.info("操作完成，程序结束！")
    logger.info(f"Markdown中引用的图片有 {len(pictures_in_markdown)} 个！")
    logger.info(f"目录中的图片有 {len(pictures_in_directory)} 个！")
    logger.info(f"冗余的图片有 {len(redundant_images)} 个")


if __name__ == "__main__":
    main()
