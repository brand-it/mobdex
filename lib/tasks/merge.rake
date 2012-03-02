namespace :clean do
  task :tags => :environment do
    removed_tags = 0
    count = 0
    removed_count = 0
    
    
    taggings = Tagging.all
    for tagging in taggings
      if tagging.tag
        tags = Tag.find(:all, :conditions => "lower(name) = '#{tagging.tag.name.downcase}'")
        for tag in tags
          # puts tagging.tag.name + "." + tagging.tag_id.to_s + " " + tag.name + "." + tag.id.to_s
          if tag.id != tagging.tag_id
            if tag.delete
              puts "Tag " + tagging.tag.name + " has been merged and removed."
              removed_tags += 1
            end
          end
        end
      else
        tagging.delete
        removed_count += 1
      end
    end
    
    tags = Tag.all
    for tag in tags
      if tag.domains.count == 0
        if tag.delete
          puts "Tag " + tag.name + " has been merged and removed."
          removed_tags += 1
        end
      end
    end
    
    taggings = Tagging.all

    for tagging in taggings
      if tagging.tag && tagging.domain
        count += 1
      else
        if tagging.delete
          removed_count += 1
        end
      end
    end
    
    puts "total number of removed tags " + removed_tags.to_s
    puts "total number of working taggings is " + count.to_s
    puts "total number of taggings removed is " + removed_count.to_s
    
  end
end