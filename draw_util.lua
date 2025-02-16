function draw_image_xywh(image, x, y, w, h)
    image:draw(x, y, x + w, y + h)
end