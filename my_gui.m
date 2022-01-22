function my_gui()
close all
    fig=figure('Position',[300 100 750 550],'Name','Iris','NumberTitle','off');
    p=uipanel('Title','Iris feature','Units' , 'pixels' , 'Position',[20 30 710 510]);
    status=uicontrol('Style','text','FontSize',10,'HorizontalAlignment','left','Position',[0 0 1100 20]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global link select load iris chk
     link=uicontrol('Parent',p,'Style','edit','string','','Position',[10 445 600 30]);
     select=uicontrol('Parent',p,'Style','pushbutton','string','Select File','Position',[620 445 80 30],'Callback',{@select_img});
     load=uicontrol('Parent',p,'Style','pushbutton','string','Load','Position',[620 300 80 30],'Callback',{@load_iris});
     iris=uicontrol('Parent',p,'Style','pushbutton','string','Iris recognize','Position',[620 250 80 30],'Callback',{@iris_recognize});
    chk=uicontrol('Parent',p,'Style','pushbutton','string','search','Position',[620 70 80 30],'Callback',{@matching});
   % res=uicontrol('Parent',p,'Style','text','FontSize',10,'HorizontalAlignment','left','Position',[10 70 600 30]');
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    org_im=axes('Parent',p,'Units' , 'pixels' , 'Position',[320 180 270 200]);
    imshow(ones(199,270));
    title('orginal image');
    
    seg_im=axes('Parent',p,'Units' , 'pixels' , 'Position',[20 180  270 200]);
    imshow(ones(200,270));
    title('segmented image');
    
     im_template=axes('Parent',p,'Units' , 'pixels' , 'Position',[320 105 260 40]);
    imshow(ones(20,480));
    title('Template');
    
    im_mask=axes('Parent',p,'Units' , 'pixels' , 'Position',[20 105 260 40]);
    imshow(ones(20,480));
    title('Mask');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function select_img(~,~)
        set(status,'string','Loading File')

            [filename,pathname] = uigetfile({'*.bmp';'*.*'},'open file');
        if isequal(filename,0)
            set(status,'string',' File Open Error: No select any file');
            return;
        end
        str = [pathname filename];
        set(link,'string',str);
        set(status,'string','Select Complted')
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 function load_iris(~,~)
        global Img
        
        set(status,'string',' Loading image File');
        Img = imread(get(link,'string'));
        axes(org_im);
        imshow(Img);
        title('orginal image');
        set(status,'string','Loading Compleated');
        
 end
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 function iris_recognize(~,~)
        global template mask;
        filename=get(link,'string');
        set(status,'string','Recognizing..');
        [template,mask] = createiristemplate(filename);
        axes(im_template)
        imshow(template);
        title('Template');
        axes(im_mask)
        imshow(mask);
        title('Mask');
        
        save([filename,'-temlate.mat'],'template');
        save([filename,'-mask.mat'],'mask');
        set(status,'string','Recogniz Completed');
 end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 function matching(~,~)
        global template1 mask1 template2 mask2
        
        scales=20;
        distance = gethammingdistance(template1, mask1, template2, mask2, scales);
        if distance< 0.2999
            set(t_res,'string','matcing image')
        else
            set(t_res,'string','not matcing image')
        end

 end

end

