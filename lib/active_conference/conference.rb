module ActiveConference
  class Conference < ActiveConference::Resource

    UNSCHEDULED = 1
    PENDING = 2
    STARTING = 3
    ACTIVE = 4
    COMPLETE = 5

    def started?
      status >= STARTING
    end
  
    def participants(force_reload=false)
      unless @participants.respond_to?(:loaded?)
        @participants = ParticipantCollection.new(self)
      end
  
      @participants.reload if force_reload
  
      @participants
    end
  
  end
  
  class ParticipantCollection
  
    def initialize(conference)
      @conference = conference
      reset
    end
  
    def to_ary
      load_participants
      @participants.to_ary
    end
  
    def reset
      reset_participants!
      @loaded = false
    end
  
  
    def <<(*records)
      returning true do
        flatten_deeper(records).each do |record|
          raise_on_mismatch(record)
          @participants << record
        end
      end
    end
    alias_method :push, :<<
    alias_method :concat, :<<
  
    def ===(other)
      load_participants
      other === @participants
    end
  
    def loaded?
      @loaded
    end
  
    def length
      load_participants.size
    end
    alias :size :length
    alias :count :length
  
    def empty?
      length.zero?
    end
  
    def inspect
      reload unless loaded?
      @participants.inspect
    end
  
    def reload
      reset
      load_participants
    end
  
    def build(attributes = {})
      raise StandardError.new, 'Conference must be saved before adding participants' unless @conference.id
      if attributes.is_a?(Array)
        attributes.collect { |attr| build(attr) }
      else
        record = Participant.new(attributes.merge({:conference_id => @conference.id}))
  
        @participants ||= [] unless loaded?
        @participants << record
        
        record
      end
    end
  
    def create(attributes = {})
      raise StandardError.new, 'Conference must be saved before adding participants' unless @conference.id
      if attributes.is_a?(Array)
        attributes.collect { |attr| create(attr) }
      else
        record = Participant.create(attributes.merge({:conference_id => @conference.id}))
  
        @participants ||= [] unless loaded?
        @participants << record
        
        record
      end
    end
  
    protected
      def load_participants
        if !@loaded
          if @participants.is_a?(Array)
            @participants = (Participant.find(:all, :params => {:conference_id => @conference.id}) + @participants).uniq
          else
            @participants = Participant.find(:all, :params => {:conference_id => @conference.id})
          end
          @loaded = true
        end
        @participants.each do |p|
          p.prefix_options = {:conference_id => @conference.id}
        end
  
        @participants
      end
  
      def reset_participants!
        @participants = []
      end
  
      def raise_on_type_mismatch(record)
        unless record.is_a?(Participant)
          raise StandardError, "Participant expected, got #{record.class}"
        end
      end
  
      # Array#flatten has problems with recursive arrays. Going one level deeper solves the majority of the problems.
      def flatten_deeper(array)
        array.collect { |element| element.respond_to?(:flatten) ? element.flatten : element }.flatten
      end
  
    private
      def method_missing(method, *args, &block)
        if load_participants
          @participants.send(method, *args, &block)
        end
      end
  
  end
end
