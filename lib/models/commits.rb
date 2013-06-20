# Example Github commit post: {
#   commits: [
#   {
#     id:        commit.id,
#     message:   commit.message,
#     timestamp: commit.committed_date.xmlschema,
#     url:       commit_url,
#     added:     array_of_added_paths,
#     removed:   array_of_removed_paths,
#     modified:  array_of_modified_paths,
#     author:    {
#       name:      commit.author.name,
#       email:     commit.author.email
#     }
#   }]
# }

migration "create the commits table" do
  DB.create_table :commits do
    primary_key   :id, primary_key: true
    Integer       :github_id
    String        :url, null: false
    String        :author, null: false
    String        :message, null: false
    String        :updated_at, null: false
  end
end

class Commit < Sequel::Model
  many_to_one :github_repo

  def self.add_new_commits(github_repo, commit_jsons)
    return unless commit_jsons && github_repo

    commit_jsons.each do |commit_info|
      commit = Commit.create(
        url:        commit_info['url'],
        author:     commit_info['author']['name'],
        message:    commit_info['message'],
        updated_at: commit_info['timestamp']
      )
      github_repo.add_commit(commit)
    end
  end
end
