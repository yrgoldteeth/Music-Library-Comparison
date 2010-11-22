# cd music 
# find .|egrep 'mp3|m4'|sed 's/^\.\///g'|sed 's/\//****/g' > compare_list.txt
# cd music_master
# find .|egrep 'mp3|m4'|sed 's/^\.\///g'|sed 's/\//****/g' > master_list.txt

class MusicFixer
  MASTER_FILE = 'master_list.txt'

  attr_reader :compare_array, :master_array

  def initialize path
    raise 'no file' unless File.exist?(path)

    @master_array  = parse!(MASTER_FILE)
    @compare_array = parse!(path)
  end

  def inspect
    %{#{self.class}}
  end
  
  def artists_not_in_master
    compare_artists - (master_artists & compare_artists)
  end

  def tracks_not_in_master
    compare_tracks - (master_tracks & compare_tracks)
  end

  def master_tracks
    @master_tracks ||= tracks(master_array)
  end

  def compare_tracks
    @compare_tracks ||= tracks(compare_array)
  end

  def master_artists
    @master_artists ||= artists(master_array)
  end

  def compare_artists
    @compare_artists ||= artists(compare_array)
  end

  private
  def artists ary=[]
    ary.map{|x|x.first}.uniq
  end

  def tracks ary=[]
    ary.map{|x|%{#{x.first}-#{x.last}}}
  end

  # data format:
  # Artist****Album****SongName.mp3\n
  def parse! path
    File.open(path).readlines.map{|l|l.chomp.downcase.gsub(/^the /,'').split('****').values_at(0,-1)}
  end

end
