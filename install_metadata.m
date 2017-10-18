files_to_copy = { 
    'C:\Users\mbmhscc4\MATLAB\MRI\SoundPicture\concept_list.mat'
    'D:\MRI\SoundPicture\data\MAT\avg\bystudy\metadata_avg_wAnimate.mat'
};
destination_dir = 'C:\Users\mbmhscc4\MATLAB\src\RSA_Toolbox_Analysis\data';
for i = 1:numel(files_to_copy)
    source_file = files_to_copy{i};
    [p,f,e] = fileparts(source_file);
    filename = [f e];
    destination_file = fullfile(destination_dir, filename);
    copyfile(source_file, destination_file);
    fprintf('%s -> %s\n', source_file, destination_file);
end

subject_codes = {
    'MD106_050913'
    'MD106_050913B'
    'MRH026_201'
    'MRH026_202'
    'MRH026_203'
    'MRH026_204'
    'MRH026_205'
    'MRH026_206'
    'MRH026_207'
    'MRH026_208'
    'MRH026_209'
    'MRH026_210'
    'MRH026_211'
    'MRH026_212'
    'MRH026_213'
    'MRH026_214'
    'MRH026_215'
    'MRH026_216'
    'MRH026_217'
    'MRH026_218'
    'MRH026_219'
    'MRH026_220'
    'MRH026_221'
};
save(fullfile(destination_dir, 'subject_codes.mat'), 'subject_codes');
fprintf('Saved %s.\n', fullfile(destination_dir, 'subject_codes.mat'))

fprintf('done.\n');