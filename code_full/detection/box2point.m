function point = box2point(box)

point = [(box(:,1) + box(:,3))/2 (box(:,2) + box(:,4))/2];