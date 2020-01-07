library('oasis-pipeline')

oasisMultistreamMoleculePipeline {
  upstream_git_url = 'https://github.com/oasis-roles/osp_templates.git'
  molecule_role_name = 'osp_templates'
  molecule_scenarios = []
  properties = [pipelineTriggers([cron('H H * * *')])]
}
