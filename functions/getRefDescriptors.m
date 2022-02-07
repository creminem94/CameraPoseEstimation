function res = getRefDescriptors(p2D, p3D, f, d)
    nPoints = size(f,2);
    res(nPoints) = struct();
    for i = 1:nPoints
        p2DIdx = dsearchn(p2D, f(1:2, i)');
        res(i).p2D = p2D(p2DIdx,:);
        res(i).p3D = p3D(p2DIdx,:);
        res(i).f = f(:,i);
        res(i).d = d(:,i);
    end
end

