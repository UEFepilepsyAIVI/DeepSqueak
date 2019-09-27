function [relativeBox] = calculateRelativeBox(box,axes)

    axis_xlim = xlim(axes);
    axis_ylim = ylim(axes);
    
    relative_x = box(1) - axis_xlim(1);
    relative_y = box(2) - axis_ylim(1);
    relative_width = box(3) / ( axis_xlim(2) - axis_xlim(1));
    relative_heigth = box(4) / (axis_ylim(2) - axis_ylim(1));
    
    relativeBox = [relative_x relative_y relative_width relative_heigth];

end

