from PIL import Image
import os

def is_image_file(filepath):
    image_extensions = {'.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.tif', '.webp', '.svg'}
    _, ext = os.path.splitext(filepath)
    return ext.lower() in image_extensions

for cafe in os.listdir("./resource/img"):
    if os.path.isdir(f"./resource/img/{cafe}"):
        for img in os.listdir(f"./resource/img/{cafe}"):
            if is_image_file(img):
                image_path = f"./resource/img/{cafe}/{img}"
                print(image_path)

                with open(image_path, 'rb') as f:
                    # Open the original image
                    original_image = Image.open(f)
                    original_image = original_image.convert('RGB')

                    # Get the original dimensions
                    original_width, original_height = original_image.size

                    # Define the desired width (between 100 and 120)
                    desired_width = min(max(original_width, 450), 500)

                    # Calculate the new height to maintain the aspect ratio
                    aspect_ratio = original_height / original_width
                    new_height = int(desired_width * aspect_ratio)

                    # Resize the image
                    resized_image = original_image.resize((desired_width, new_height), Image.LANCZOS)

                    # Save the resized image
                    resized_image.save(image_path)

                    print(f"Resized image saved with dimensions: {resized_image.size}")
