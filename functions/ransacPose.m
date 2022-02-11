function [bestModel, inliers, outliers, inliersIdx] = ransacPose(points,maxIter,t,d)
    i = 0;
    rng('shuffle');
    while i < maxIter
        i = i+1;
        idx1 = randi(length(points));
        idx2 = randi(length(points));
        idx3 = randi(length(points));
        while idx2 == idx1
            idx2 = randi(length(points));
        end
        while idx3 == idx1 || idx3 == idx2
            idx3 = randi(length(points));
        end
    
        %model
        A = points(idx1,:);
        B = points(idx2,:);
        C = points(idx3,:);
        plane = getPlane(A, B, C);
        inliers = [];
        outliers = [];
        inliersIdx = [];
        for j = 1:length(points)
            if j == idx1 || j == idx2
                continue;
            end
            P = points(j,:);
            dist = point2planeDist(P, plane);
            if abs(dist) <= t
                inliers = [inliers; P];
                inliersIdx = [inliersIdx j];
            else
                outliers = [outliers;P];
            end
        end
        if length(inliers) >= d
            break;
        end       
    end
    bestModel = plane;
end

