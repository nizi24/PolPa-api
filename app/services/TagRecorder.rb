class TagRecorder

  def initialize(time_report)
    @time_report = time_report
  end

  def create_links(tags)
    if tags
      tags = tags['tags']
      tags.each do |t|
        name = t['text']
        tag = Tag.find_or_create_by(name: name)
        @time_report.links.create!(tag_id: tag.id)
      end
    end
  end
end
