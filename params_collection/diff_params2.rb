require_relative 'lib/dudegl.rb'

params_list1 =   []

params_list2 =   [{:name=>"OauthCallbacksController", :methods=>[{:name=>:github, :args=>0, :length=>2, :conditions=>0}, {:name=>:oauth_provider, :args=>1, :length=>46, :conditions=>2}], :references=>["User"]}, {:name=>"ReposController", :methods=>[{:name=>:index, :args=>0, :length=>8, :conditions=>0}, {:name=>:refresh, :args=>0, :length=>7, :conditions=>0}, {:name=>:monitor, :args=>0, :length=>11, :conditions=>0}, {:name=>:not_monitor, :args=>0, :length=>11, :conditions=>0}, {:name=>:add_to_monitored, :args=>0, :length=>17, :conditions=>1}, {:name=>:remove_from_monitored, :args=>0, :length=>17, :conditions=>1}, {:name=>:id, :args=>0, :length=>4, :conditions=>0}, {:name=>:repo_id, :args=>0, :length=>4, :conditions=>0}, {:name=>:get_current_user_repos, :args=>0, :length=>8, :conditions=>0}, {:name=>:update_user_repos, :args=>0, :length=>12, :conditions=>0}, {:name=>:update_repository, :args=>1, :length=>29, :conditions=>1}, {:name=>:load_repos, :args=>0, :length=>12, :conditions=>2}], :references=>["GithubService", "Repo"]}, {:name=>"ApplicationRecord", :methods=>[], :references=>[]}, {:name=>"User", :methods=>[{:name=>:create_authorization!, :args=>1, :length=>12, :conditions=>0}], :references=>["FindForOauth"]}, {:name=>"GitDiffService", :methods=>[], :references=>["ALLOWED_EXTENSION", "EXCLUDE_ROOT_FOLDERS", "PATTERN_MATCH"]}, {:name=>"Task3", :methods=>[{:name=>:init, :args=>1, :length=>2, :conditions=>0}, {:name=>:checked?, :args=>2, :length=>1, :conditions=>0}], :references=>[]}]


dudes = DudeGl.new [params_list1, params_list2], dudes_per_row_max: 2, diff: true
dudes.render
dudes.save 'dudes_diff_3'

pp dudes.save_to_string[0..100]
