function res = getRefDescriptors(p2D, p3D, descr)
    nPoints = size(descr,2);
    res(nPoints) = struct();
    for i = 1:nPoints
        p2DIdx = dsearchn(p2D, descr(1:2, i)');
        res(i).p3D = p3D(p2DIdx,:);
        res(i).descr = descr(:,1);
    end
end

