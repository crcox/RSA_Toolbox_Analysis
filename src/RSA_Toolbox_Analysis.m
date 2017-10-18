% RSA_Toolbox_Analysis
% Derived from Recipe_fMRI_searchlight
%
% Cai Wingfield 11-2009, 2-2010, 3-2010, 8-2010
% Chris Cox 10-2017
%__________________________________________________________________________
% Copyright (C) 2010 Medical Research Council

function RSA_Toolbox_Analysis(condition, varargin)
    p = inputParser();
    HasInputError = false;
    if isdeployed
        addRequired(p, 'condition');
        addParameter(p, 'metadata', 'metadata_avg_wAnimate.mat');
        addParameter(p, 'concept_list', 'concept_list.mat');
        addParameter(p, 'subject_codes', 'subject_codes.mat');
        addParameter(p, 'permutation_index', 'PERMUTATION_INDEX.mat');
        addParameter(p, 'random_seeds', '1');
        addParameter(p, 'radius', '9');
        addParameter(p, 'beta_path', '');
        addParameter(p, 'mask_path', '');
        addParameter(p, 'output_root', '');
        parse(p, condition, varargin{:});
        fprintf('condition: %s\n', p.Results.condition);
        fprintf('metadata: %s\n', p.Results.metadata);
        fprintf('concept_list: %s\n', p.Results.concept_list);
        fprintf('subject_codes: %s\n', p.Results.subject_codes);
        
        % Convert string input to numeric
         radius = str2double(p.Results.radius);
         random_seeds = str2double(strsplit(p.Results.random_seeds));
        
        if isempty(p.Results.beta_path);
            fprintf('beta_path: %s\n', '[embedded]');
        else
            fprintf('beta_path: %s\n', p.Results.beta_path);
        end
        if isempty(p.Results.mask_path);
            fprintf('mask_path: %s\n', '[embedded]');
        else
            fprintf('mask_path: %s\n', p.Results.mask_path);
        end
        if isempty(p.Results.output_root);
            HasInputError = true; %#ok<NASGU>
            error('You must supply a path to where output should be written.');
        else
            fprintf('output_root: %s\n', p.Results.output_root);
        end
        % Dependencies are bundled with the build.
        dataroot = '';
        
    else
        addRequired(p, 'condition');
        addParameter(p, 'metadata', 'D:\MRI\SoundPicture\data\MAT\avg\bystudy\metadata_avg_wAnimate.mat');
        addParameter(p, 'concept_list', 'C:\Users\mbmhscc4\MATLAB\MRI\SoundPicture\concept_list.mat');
        addParameter(p, 'subject_codes', 'C:\Users\mbmhscc4\MATLAB\src\RSA_Toolbox_Analysis\data\subject_codes.mat')
        addParameter(p, 'permutation_index', 'D:\MRI\SoundPicture\data\MAT\avg\bystudy\PERMUTATION_INDEX.mat');
        addParameter(p, 'random_seeds', 1);
        addParameter(p, 'radius', 9);
        addParameter(p, 'beta_path', 'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED');
        addParameter(p, 'mask_path', 'D:\MRI\SoundPicture\data\MODEL\RICK_COMBINED');
        addParameter(p, 'output_root', '');

        parse(p, condition, varargin{:});
        fprintf('condition: %s\n', p.Results.condition);
        fprintf('metadata: %s\n', p.Results.metadata);
        fprintf('concept_list: %s\n', p.Results.concept_list);
        fprintf('subject_codes: %s\n', p.Results.subject_codes);
        
        % Pull numeric variables out of the structure
        random_seeds = p.Results.random_seeds;
        radius = p.Results.radius;
        
        if isempty(p.Results.beta_path);
            HasInputError = true;
            warning('You must supply a path to where betas can be found.');
        else
            fprintf('beta_path: %s\n', p.Results.beta_path);
        end
        if isempty(p.Results.mask_path);
            HasInputError = true;
            warning('You must supply a path to where masks can be found.');
        else
            fprintf('mask_path: %s\n', p.Results.mask_path);
        end
        if isempty(p.Results.output_root);
            HasInputError = true;
            warning('You must supply a path to where output should be written.');
        else
            fprintf('output_root: %s\n', p.Results.output_root);
        end
        
        toolboxRoot = 'C:\Users\mbmhscc4\MATLAB\src\RSA_Toolbox_Analysis\dependencies\rsatoolbox';
        addpath(fullfile(toolboxRoot,'Modules'));
        addpath(fullfile(toolboxRoot,'Engines'));
        addpath('C:\Users\mbmhscc4\MATLAB\src\RSA_Toolbox_Analysis\dependencies\spm12_minimal');
        dataroot = 'C:\Users\mbmhscc4\MATLAB\src\RSA_Toolbox_Analysis\data';
        
    end
    if HasInputError
        error('RSA_Toolbox_Analysis:InputError','There were problems with the supplied inputs. Please review the warnings and try again.');
    end
    
    ImageDataFile = fullfile(dataroot, sprintf('%s_ImageData.mat', p.Results.condition));
    MasksFile = fullfile(dataroot, sprintf('%s_Masks.mat', p.Results.condition));
    ModelRDMsFile = fullfile(dataroot, sprintf('%s_Models.mat', p.Results.condition));
    
    % N.B. loadAs() is defined at the bottom of this file.
    metadata          = loadAs(p.Results.metadata, 'metadata');
    concept_list      = loadAs(p.Results.concept_list, 'concept_list');
    subject_codes     = loadAs(p.Results.subject_codes, 'subject_codes');
    fullBrainVols     = loadAs(ImageDataFile, 'fullBrainVols');
    binaryMasks_nS    = loadAs(MasksFile, 'binaryMasks_nS');
    models            = loadAs(ModelRDMsFile, 'Models');
    PERMUTATION_INDEX = loadAs(p.Results.permutation_index, 'PERMUTATION_INDEX');
    PERMUTATION_INDEX = PERMUTATION_INDEX{1};

    AnimateTarget = selectbyfield(metadata(1).targets, 'label', 'animate', 'type', 'category');
    animate = AnimateTarget.target > 0;
    
    NotRainFilter = selectbyfield(metadata(1).filters, 'label', 'NOT_rain', 'dimension', 1);
    not_rain = NotRainFilter.filter > 0;
    
    condition_colors = repmat([0,0,1], numel(concept_list), 1);
    condition_colors(animate, :) = repmat([1,0,0], nnz(animate), 1);

    beta_template = struct('identifier', sprintf('beta_%04d.nii', 1));

    output_dir = fullfile(p.Results.output_root,condition,'permutations');
    if ~exist(output_dir, 'dir')
        mkdir(outputdir);
    end
    override = struct( ...
        'analysisName', '', ...
        'rootPath', output_dir, ...
        'betaPath', fullfile(p.Results.beta_path,'[[subjectName]]','[[betaIdentifier]]'), ...
        'maskPath', fullfile(p.Results.mask_path,'[[subjectName]]','[[maskName]]'), ...
        'maskNames', {{'mask.nii'}}, ...
        'structuralsPath', [], ...
        'voxelSize', [3, 3, 4], ...
        'searchlightRadius', radius, ...
        'subjectNames', {subject_codes}, ...
        'conditionLabels', {concept_list(not_rain)}, ...
        'conditionColours', {condition_colors(not_rain)}, ...
        'getSPMData', 0 ...
    );
    userOptions = defineUserOptions();
    fn = fieldnames(override);
    for i = 1:numel(fn)
        if ~isfield(userOptions, fn{i})
            error('invalid field name %s.', fn{i});
        end
        userOptions.(fn{i}) = override.(fn{i});
    end
    userOptions = rmfield(userOptions, 'structuralsPath');
    
    for r = 1:numel(random_seeds)
        RandomSeed = random_seeds(r);
        userOptions.analysisName = sprintf('%s_perm%03d', p.Results.condition, RandomSeed);

        [~, ix] = sort(PERMUTATION_INDEX(not_rain, RandomSeed));
        [~, permutation_index] = sort(ix);
        
        for i = 1:numel(models)
            models(i).RDM = models(i).RDM(permutation_index, permutation_index);
        end

        fMRISearchlight(fullBrainVols, binaryMasks_nS, models, beta_template, userOptions);
    end
end

function y = loadAs(x, name)
% LOADAS Loads a single, named variable from file to a variable.
    tmp = load(x, name);
    y = tmp.(name);
end