from PIL import Image, ImageDraw

icon = Image.open("app/assets/icon/app_icon.png").convert("RGBA")
width, height = icon.size

background = Image.new("RGBA", (width, height))
draw = ImageDraw.Draw(background)

top_color    = (139, 158, 200)
bottom_color = (200, 160, 188)

for y in range(height):
    ratio = y / height
    r = int(top_color[0] + (bottom_color[0] - top_color[0]) * ratio)
    g = int(top_color[1] + (bottom_color[1] - top_color[1]) * ratio)
    b = int(top_color[2] + (bottom_color[2] - top_color[2]) * ratio)
    draw.line([(0, y), (width, y)], fill=(r, g, b, 255))

background.paste(icon, (0, 0), icon)
background = background.convert("RGB")
background.save("app/assets/icon/app_icon_android.png")
print("Done: app_icon_android.png")
