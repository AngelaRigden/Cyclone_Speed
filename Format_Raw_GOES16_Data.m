% Download and format GOES data in matlab
% Angela Rigden, July 23, 2018

%%%%%%%%%%%%% Options: %%%%%%%%%%%%%
level = '1b';
channel = 13;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

goes_prefix = ['OR_ABI-L',level,'-RadM1-M3C',sprintf('%02d',channel),'_G16'];


for M = 1 % 1 == IRMA
    % ABI Mesoscale Image Number
    % "1" = Region 1; "2" = Region 2
    
    for YR = 2017 % Year, 2017-2018
        
        for DY = 248:253 % DOY, 1-365, 248:253 = IRMA
            
            url_list = Read_M3C13_URLs(['URLs/M3C13_day',num2str(DY),'.txt']);
            
            for HR = 0:23 % HR, 0-23
                
                disp(['DY ',num2str(DY),', HR',num2str(HR)])
                
                file_dir_save_nc = ['ABI-L1b-RadM/',num2str(YR),'/',num2str(DY),'/',sprintf('%02d',HR)];
                folder_contents = dir(file_dir_save_nc);
                file_list = folder_contents(arrayfun(@(x) ~strcmp(x.name(1),'.'),folder_contents));
                
                % Just look at Region M:
                file_list_reg = file_list(arrayfun(@(x) strcmp(x.name(16),num2str(M)),file_list));
                
                
                file_save_mat = [dir_save_mat,'/OR_ABI-L1b-RadM',num2str(M),...
                    '-M3C13_G16_s',num2str(YR),num2str(DY),sprintf('%02d',HR),'.mat'];
                
                if ~exist(file_save_mat,'file')
                    
                    if ~isempty(file_list_reg)
                        
                        num_files_hr_reg = length(file_list_reg);
                        Rad = zeros(500,500,num_files_hr_reg)+NaN;
                        x = zeros(500,num_files_hr_reg)+NaN;
                        y = zeros(500,num_files_hr_reg)+NaN;
                        t = zeros(num_files_hr_reg,1)+NaN;
                        perspective_point_height = zeros(num_files_hr_reg,1)+NaN;
                        longitude_of_projection_origin = zeros(num_files_hr_reg,1)+NaN;
                        
                        for II = 1:num_files_hr_reg
                            
                            file_name_ii = file_list_reg(II).name;
                            file_path_ii = file_list_reg(II).folder;
                            
                            Rad(:,:,II) = ncread([file_path_ii,'/',file_name_ii],'Rad');
                            x(:,II) = ncread([file_path_ii,'/',file_name_ii],'x');
                            y(:,II) = ncread([file_path_ii,'/',file_name_ii],'y');
                            t(II) = ncread([file_path_ii,'/',file_name_ii],'t');
                            
                            perspective_point_height(II) = ncreadatt([file_path_ii,'/',file_name_ii],...
                                'goes_imager_projection', 'perspective_point_height');
                            
                            longitude_of_projection_origin(II) = ncreadatt([file_path_ii,'/',file_name_ii],...
                                'goes_imager_projection', 'longitude_of_projection_origin');
                        end % II, sub-hour
                        
                        dir_save_mat = ['ABI-L1b-RadM-mat/Region_M',...
                            num2str(M),'/',num2str(YR),'/',num2str(DY)];
                        if ~exist(dir_save_mat,'dir')
                            mkdir(dir_save_mat)
                        end
                        
                        check_dat_movie = 0;
                        if check_dat_movie == 1
                            v = VideoWriter([file_name_ii(1:37),'.avi']); %#ok<TNMLP>
                            open(v);
                            for k = 1:num_files_hr_reg
                                imagesc(Rad(:,:,k))
                                frame = getframe(gcf);
                                writeVideo(v,frame);
                            end
                            close(v);
                        end
                        
                        save(file_save_mat,'Rad','x','y','t',...
                            'perspective_point_height','longitude_of_projection_origin')
                        
                    else
                        error('No data for that hour?! Check again...')
                    end % ~isempty (make sure there are two regions)
                end
            end % HR (hour)
        end % DY (day)
    end % YR (year)
end % M (Rregion)


