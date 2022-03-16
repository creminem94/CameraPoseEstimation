function  plotCameraOnImage(R, T)
    plot3(T(1), T(2), T(3),'-o','Color','b','MarkerSize',10);
    
    ref = R.*100;
    hold on;
    f1 = quiver3(T(1), T(2), T(3),ref(1,1),ref(2,1),ref(3,1),'Color','r','DisplayName','t');
    f2 = quiver3(T(1), T(2), T(3),ref(1,2),ref(2,2),ref(3,2),'Color','g','DisplayName','n');
    f3 = quiver3(T(1), T(2), T(3),ref(1,3),ref(2,3),ref(3,3),'Color','b','DisplayName','b');
end

