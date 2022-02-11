function dist = point2planeDist(point,planePars)
    %(dot([a b c], point)+d)/norm([a b c])
    dist = abs(dot(planePars(1:3),point)+planePars(4))/norm(planePars(1:3));
end

