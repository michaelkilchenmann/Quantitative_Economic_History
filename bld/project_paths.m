function[path] = project_paths(key,arg)
%Paths script for Matlab:
%Use command project_paths(key,arg) to obtain the absolute path to the
%directory *key* refers to, with the string in *arg* appended.
%
%For example:
%project_paths('OUT_TABLES','table1.tex') returns your equivalent of
%D:\workspace\project\trunk\bld\out\tables\table1.tex
%
%project_paths('OUT_ANALYSIS','logs\reg.log') returns your equivalent of
%D:\workspace\project\trunk\bld\out\analysis\logs\reg.log
%
%Note: *arg* is optional.
%
%File is created by waf. Do not change paths here, but in root wscript!

projectpaths.IN_DATA = 'C:\WAF\V7\src\original_data';
projectpaths.LIBRARY = 'C:\WAF\V7\src\library';
projectpaths.OUT_DATA = 'C:\WAF\V7\bld\out\data';
projectpaths.OUT_FIGURES = 'C:\WAF\V7\bld\out\figures';
projectpaths.OUT_TABLES = 'C:\WAF\V7\bld\out\tables';
projectpaths.PROJECT_ROOT = 'C:\WAF\V7';

%define arg if not given
if ~exist('arg','var')
  arg='';
end

path=[getfield(projectpaths, key) '/' arg];
