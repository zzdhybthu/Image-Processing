from PIL import Image
import os

def convert_bmp_to_png(bmp_path, png_path):
    with Image.open(bmp_path) as img:
        img.save(png_path, 'PNG')

for root, dirs, files in os.walk('asserts'):
    for file in files:
        if file.endswith('.bmp'):
            bmp_path = os.path.join(root, file)
            png_path = bmp_path.replace('.bmp', '.png')
            convert_bmp_to_png(bmp_path, png_path)
            print(f'Converted {bmp_path} to {png_path}')
