function [sx, sy, sWidth, sHeight] = auto_crop ( f )
    dis = true;
    %error window size
    global erm;
    global er;
    er = 71;
    erm = uint32(floor( er / 2));
    sz = size(f);
    %center of image
    oriMid = uint32(sz ./ 2);
    %window size
    ws = sz / 100;
    %window value
    imW = f( oriMid(1) - ws(1) : oriMid(1) + ws(1) , oriMid(2) - ws(2) : oriMid(2) + ws(2) ,:);
    %tresholds
    tresh = mean(mean(imW));
    
    r = f(: , : , 1) ;
    g = f(: , : , 2) ;
    b = f(: , : , 3) ;
    
    %for error
    s = 20;
    r = (r >= tresh(:,:,1) - s);
    g = (g >= tresh(:,:,2) - s );
    b = (b >= tresh(:,:,3) - s);
    %and operation
    o = r & g & b ;
    
    midX = oriMid;
    preMidX = midX;
    %find top left corner
    value = o(midX(1) , midX(2));
    
    while(value == 1 && midX(2) > 1 )
        preMidX = midX;
        midX(2) = uint32(midX(2) ./2);
        value =  orLogic(o , midX(1) , midX(2) , 1 );
    end;

    midY = preMidX;
    preMidY = midY;
    value = o(midY(1) , midY(2));
    while(value == 1 && midY(1) > 1 )
        preMidY = midY;
        midY(1) = uint32(midY(1) ./2);
        value =orLogic(o , midY(1) , midY(2) , 2 );
    end;

    leftAnchor = [preMidY(1) , preMidY(2)];
    value = orLogic( o , leftAnchor(1) , leftAnchor(2)  , 1);
    while( value ~= 0 && leftAnchor(2) > 1)
        leftAnchor(2) = leftAnchor(2) - 1;
        value = orLogic( o , leftAnchor(1) , leftAnchor(2) , 1);
    end;
    leftAnchor(2) = leftAnchor(2) + erm; %uint32(erm); % erorr correctn
    value = orLogic( o , leftAnchor(1) , leftAnchor(2) , 2);
    while(value ~= 0 && leftAnchor(1) > 1)
        leftAnchor(1) = leftAnchor(1) - 1;
        value = orLogic( o , leftAnchor(1) , leftAnchor(2) , 2);
    end;

    %left bottom
    midY = preMidX;
    preMidY = midY;
    value = o(midY(1) , midY(2));
    while(value == 1 && midY(1) < sz(1) )
        preMidY = midY;
        midY(1) = uint32((sz(1) + midY(1)) ./2);
        value =orLogic(o , midY(1) , midY(2) , 2 );
    end;

    leftAnchor2 = [preMidY(1) , preMidY(2)];
    value = orLogic( o , leftAnchor2(1) , leftAnchor2(2)  , 1);
    while( value ~= 0 && leftAnchor2(1)< sz(1))
        leftAnchor2(1) = leftAnchor2(1) + 1;
        value = orLogic( o , leftAnchor2(1) , leftAnchor2(2) , 1);
    end;
    leftAnchor2(1) = leftAnchor2(1) - erm; %uint32(erm); % erorr correctn
    value = orLogic( o , leftAnchor2(1) , leftAnchor2(2) , 2);
    while(value ~= 0 && leftAnchor2(2) > 1)
        leftAnchor2(2) = leftAnchor2(2) - 1;
        value = orLogic( o , leftAnchor2(1) , leftAnchor2(2) , 2);
    end;

    
    
    
    %%%%rght bottom
    midX = oriMid;
    preMidX = midX;
    value = o(midX(1) , midX(2));
    %mid x
    while(value == 1 && midX(2) < sz(2)  )
        preMidX = midX;
        midX(2) = uint32((sz(2) + midX(2)) ./2);
        value =  orLogic(o , midX(1) , midX(2) , 1 );
    end;

    midY = preMidX;
    preMidY = midY;
    value = o(midY(1) , midY(2));
    while(value == 1 && midY(1) < sz(1) )
        preMidY = midY;
        midY(1) = uint32((sz(1) + midY(1)) ./2);
        value =orLogic(o , midY(1) , midY(2) , 2 );
    end;

    rightAnchor = [preMidY(1) , preMidY(2)];
    value = orLogic( o , rightAnchor(1) , rightAnchor(2)  , 1);
    while( value ~= 0 && rightAnchor(2) < sz(2))
        rightAnchor(2) = rightAnchor(2) +1;
        value = orLogic( o , rightAnchor(1) , rightAnchor(2) , 1);
    end;
    
    rightAnchor(2) = rightAnchor(2) - erm; %uint32(erm); % erorr correctn
    value = orLogic( o , rightAnchor(1) , rightAnchor(2) , 2);
    while(value ~= 0 && rightAnchor(1) < sz(1))
        rightAnchor(1) = rightAnchor(1) + 1;
        value = orLogic( o , rightAnchor(1) , rightAnchor(2) , 2);
    end;

    %rgt top
    midY = preMidX;
    preMidY = midY;
    value = o(midY(1) , midY(2));
    while(value == 1 && midY(1) > 1)
        preMidY = midY;
        midY(1) = uint32(( midY(1)) ./2);
        value =orLogic(o , midY(1) , midY(2) , 2 );
    end;

    rightAnchor2 = [preMidY(1) , preMidY(2)];
    value = orLogic( o , rightAnchor2(1) , rightAnchor2(2)  , 1);
    while( value ~= 0 && rightAnchor2(1) > 1)
        rightAnchor2(1) = rightAnchor2(1) - 1;
        value = orLogic( o , rightAnchor2(1) , rightAnchor2(2) , 1);
    end;
   
    rightAnchor2(1) = rightAnchor2(1) + erm; %uint32(erm); % erorr correctn
    value = orLogic( o , rightAnchor2(1) , rightAnchor2(2) , 2);
    while(value ~= 0 && rightAnchor2(2) < sz(2))
        rightAnchor2(2) = rightAnchor2(2) + 1;
        value = orLogic( o , rightAnchor2(1) , rightAnchor2(2) , 2);
    end;
    
    
    
    


    scaleSq = 700 ;
    scale = sz / 10;
    %adjust top x
    if((leftAnchor(2) - leftAnchor2(2))^2  < scaleSq )
        if(leftAnchor(2) < leftAnchor2(2) && (  oriMid(2) - leftAnchor2(2)  > scale(2) )) 
            leftAnchor(2) = leftAnchor2(2);
        end
    else
         if(leftAnchor(2) > leftAnchor2(2) && ( oriMid(2) - leftAnchor2(2)   > scale(2) )) 
            leftAnchor(2) = leftAnchor2(2);
         end
    end;
    
    
    %adjust top y
    if((leftAnchor(1) - rightAnchor2(1))^2  < scaleSq )
        if(leftAnchor(1) < rightAnchor2(1)&& ( oriMid(1) - rightAnchor2(1)  > scale(1) )) 
            leftAnchor(1) = rightAnchor2(1);
        end
    else
         if(leftAnchor(1) > rightAnchor2(1)&& ( oriMid(1) - rightAnchor2(1)  > scale(1) )) 
            leftAnchor(1) = rightAnchor2(1);
         end
    end;
    
    
    %adjust bottom y
    if((rightAnchor(1) - leftAnchor2(1))^2  < scaleSq )
        if(rightAnchor(1) < leftAnchor2(1)&& ( leftAnchor2(1)  - oriMid(1)   > scale(1) )) 
            rightAnchor(1) = leftAnchor2(1);
        end
    else
         if(rightAnchor(1) > leftAnchor2(1)&& ( leftAnchor2(1)  - oriMid(1)  > scale(1) )) 
            rightAnchor(1) = leftAnchor2(1);
         end
    end;
    
    
     %adjust botm x
    if((rightAnchor(2) - rightAnchor2(2))^2  < scaleSq )
        if(rightAnchor(2) < rightAnchor2(2) && (  rightAnchor2(2) - oriMid(2)   > scale(2) )) 
            rightAnchor(2) = rightAnchor2(2);
        end
    else
         if(rightAnchor(2) > rightAnchor2(2)&& (   rightAnchor2(2) - oriMid(2)   > scale(2) )) 
            rightAnchor(2) = rightAnchor2(2);
         end
    end;
    epx = 0;%((rightAnchor(2) - oriMid(2)) - (oriMid(2)  - leftAnchor(2))) / 4  ;
    epy = 0;%((rightAnchor(1) - oriMid(1)) - (oriMid(1)  - leftAnchor(1))) / 4  ;
    
    sx = leftAnchor(2) - epx;
    sy = leftAnchor(1) - epy;
    sWidth = rightAnchor(2) - leftAnchor(2) + epx;
    sHeight = rightAnchor(1) - leftAnchor(1) + epy;

    if(sWidth <= 50) 
        sWidth =  sz(1)/3; 
    end
    if(sHeight <= 50) 
        sHeight =  sz(2)/3; 
    end;
    
    %for debug
    if(dis == true)
        %figure ; imshow(r) ; title('Red Channel after threshold');
        %figure ; imshow(g) ; title('Green Channel after threshold');
        %figure ; imshow(b) ; title('Blue Channel after threshold');
        figure ; imshow(o) ; title('Segmented Image');
        hold on;
        plot(leftAnchor(2) ,leftAnchor(1) ,'r.','MarkerSize',50);
        hold on;
        plot(rightAnchor(2) ,rightAnchor(1) ,'r.','MarkerSize',50);
        
        hold on;
        plot(leftAnchor2(2) ,leftAnchor2(1) ,'r.','MarkerSize',50);
        
         hold on;
        plot(rightAnchor2(2) ,rightAnchor2(1) ,'r.','MarkerSize',50);
    end;
    
end

function value = orLogic(im , x , y , c )
    global er;
    global erm;
    sz = size(im);
    if((x - erm < 1 || y - erm < 1 )|| (x + erm > sz(1) || y + erm > sz(2)) )
        value = im(x , y);
        return;
    else
        randW = ones( er , er) ;%uint8(rand(er));
        imW = im( x - erm : x + erm , y - erm : y + erm);

        %value = sum(sum(randW & imW));%sum(sum(randW & imW));%/ er ;
        value = mean(mean(randW & imW));
        if(value > 0.3) 
            value = 1;
        else
            value = 0;
        end;
    end;

end





