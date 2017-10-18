files_to_copy = { 
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MD106_050913\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MD106_050913B\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_201\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_202\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_203\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_204\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_205\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_206\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_207\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_208\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_209\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_210\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_211\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_212\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_213\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_214\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_215\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_216\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_217\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_218\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_219\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_220\beta_0001.nii'
    'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED\MRH026_221\beta_0001.nii'
};
destination_root = 'C:\Users\mbmhscc4\MATLAB\src\RSA_Toolbox_Analysis\data';
for i = 1:numel(files_to_copy)
    source_file = files_to_copy{i};
    [p,bfile,e] = fileparts(source_file);
    [p,scode,~] = fileparts(p);
    filename = [bfile e];
    destination_dir = fullfile(destination_root, scode);
    if ~exist(destination_dir, 'dir');
        mkdir(destination_dir);
    end
    destination_file = fullfile(destination_dir, filename);
    copyfile(source_file, destination_file);
    fprintf('%s -> %s\n', source_file, destination_file);
end
fprintf('done.\n');