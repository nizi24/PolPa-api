class TagRecorder

  def initialize(time_report)
    @time_report = time_report
  end

  def create_links(tags)
    if tags
      tags = tags['tags']
      result = []
      tags.each do |t|
        name = t['text']
        tag = Tag.find_or_create_by(name: name)
        find_or_create(tag.id)
        result << tag
      end
      destroy_links(result)
      result
    end
  end

  private def find_or_create(tag_id)
    @time_report.links.find_by(tag_id: tag_id) ||
    @time_report.links.create!(tag_id: tag_id)
  end

  private def destroy_links(tags)
    ids = tags.map(&:id)
    current_links = @time_report.links.where(tag_id: ids)
    @time_report.links.each do |link|
      unless current_links.include?(link)
        tag_id = link.tag_id
        link.destroy!
      end
    end
  end
end
