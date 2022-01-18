function ext = compute_exterior(K, p2D, p3D, method)
% methods: 'fiore', 'iter'(anisotropic Procrustes analisys),'lowe','posit'
    if method == MethodName.Fiore
        [ext] = exterior_fiore(K,p3D',p2D');
    elseif method == MethodName.Iter
        [R,t] = exterior_iter(p2D,p3D,K)
        ext = [R t];
    elseif method == MethodName.Lowe
        G0 = eye(4);
        ext = exterior_lowe(K,p3D,p2D,G0);
    elseif method == MethodName.Posit
        [R, t] = exterior_posit(p2D, p3D, K(1,1), K(1:2,3));
        ext = [R t];
    end
end

