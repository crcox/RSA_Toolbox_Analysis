function [] = test_script(condition, random_seed)
% Runs using the data bundled with the program
    addpath('C:\Users\mbmhscc4\MATLAB\src\RSA_Toolbox_Analysis\src');
    output_root = 'D:\MRI\SoundPicture\results\RSA_Toolbox_Analysis';

    RSA_Toolbox_Analysis(condition, 'output_root', output_root, 'random_seeds', random_seed);
end