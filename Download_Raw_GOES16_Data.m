% Download GOES data in matlab
% Angela Rigden, July 23, 2018

% Filename convention:
% Level 1b product filenames are assembled using filename string fields as follows:
% <System Environment>_<DSN>_<Platform ID>_<Observation Period Start Date & Time> 
% _<Observation Period End Date & Time> _<Creation Date & Time>.<File>
% Extension>

% OR_ABI-L1b-RadF-M[34]C[04,06-16]_G16_syyyydddhhmmsss_eyyyydddhhmmsss_cyyyydddhhmmsss.nc
% sYYYYJJJHHMMSSs: Observation Start
% eYYYYJJJHHMMSSs: Observation End
% CYYYYJJJHHMMSSs: Observation Created

% Full information on filenames and contents of all GOES-16 L1b products
% can be found here:
% https://www.goes-r.gov/users/docs/PUG-L1b-vol3.pdf

% TEST IMPORTING .NC FILE:
% url = 'http://storage.googleapis.com/gcp-public-data-goes-16/ABI-L1b-RadM/2017/248/10/';
% filename_test = 'OR_ABI-L1b-RadM1-M3C13_G16_s20172481000231_e20172481000300_c20172481000334.nc';
% URL = [url,filename_test];
% urlwrite(URL,filename_test);
% ncdisp(filename_test)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% GETTING URL IS NOT AUTOMATED! %%%%%%%%%%%
% TYPE IN GOOGLE CONSOL TO GET URL FILES:
% gsutil ls gs://gcp-public-data-goes-16/ABI-L1b-RadM/2017/248/*/ | grep M3C13 > M3C13_day248.txt
% gsutil ls gs://gcp-public-data-goes-16/ABI-L1b-RadM/2017/249/*/ | grep M3C13 > M3C13_day249.txt
% gsutil ls gs://gcp-public-data-goes-16/ABI-L1b-RadM/2017/250/*/ | grep M3C13 > M3C13_day250.txt
% gsutil ls gs://gcp-public-data-goes-16/ABI-L1b-RadM/2017/251/*/ | grep M3C13 > M3C13_day251.txt
% gsutil ls gs://gcp-public-data-goes-16/ABI-L1b-RadM/2017/252/*/ | grep M3C13 > M3C13_day252.txt

% AND THEN DOWLOAD TO LOCAL COMPUTER USING "DOWNLOAD BUTTON" IN CONSOL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%% Options: %%%%%%%%%%%%%
level = '1b';
channel = 13;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

goes_prefix = ['OR_ABI-L',level,'-RadM1-M3C',sprintf('%02d',channel),'_G16'];

for YR = 2017 % Year, 2017-2018
    
    for DY = 248:253 % DOY, 1-365, 248:253 = IRMA
        
        url_list = Read_M3C13_URLs(['URLs/M3C13_day',num2str(DY),'.txt']);
        
        for HR = 0:23 % HR, 0-23
            
            disp(['DY ',num2str(DY),', HR',num2str(HR)])
            
            file_dir_save = ['ABI-L1b-RadM/',num2str(YR),'/',num2str(DY),'/',sprintf('%02d',HR)];
            if ~exist(file_dir_save,'dir')
                mkdir(file_dir_save)
            end
            
            II = find(contains(url_list,...
                ['gs://gcp-public-data-goes-16/ABI-L1b-RadM/',...
                num2str(YR),'/',num2str(DY),'/',sprintf('%02d',HR),'/']));
            
            for FILE = 1:length(II) % files within each hour
                url = ['http://storage.googleapis.com/gcp-public-data-goes-16/',...
                    'ABI-L1b-RadM/',num2str(YR),'/',num2str(DY),'/',sprintf('%02d',HR),'/'];
                full_path_url = char(url_list(II(FILE)));
                url_filename = full_path_url(55:end);
                URL = [url,url_filename];
                if ~exist([file_dir_save,'/',url_filename],'file')
                    urlwrite(URL,[file_dir_save,'/',url_filename]);
                end
            end
            
        end
    end
end

    
    
 