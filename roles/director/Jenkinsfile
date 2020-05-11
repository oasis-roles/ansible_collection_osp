library('oasis-pipeline')

oasisMultistreamMoleculePipeline {
  upstream_git_url = 'https://github.com/oasis-roles/osp_director.git'
  molecule_role_name = 'osp_director'
  molecule_scenarios = ['default']
  properties = [pipelineTriggers([cron('H H * * *')])]
}
