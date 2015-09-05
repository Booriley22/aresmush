module AresMUSH
  module FS3Sheet
    class WikiTemplate
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char)
        @char = char
      end
      
      def display
        text = "[[include characterbox%r"
        text << "|image=%r"
        text << "|actor=#{ actor }%r"
        text << "|name=#{ fullname }%r"
        text << "|age=#{ age }%r"
        text << "|birthday=#{ birthdate } %r"
        text << "|title=#{ name }%r"
        text << "|nicknames=[!-- Nicknames or aliases --]%r"
        text << "|hometown=[!-- Where you're from --]%r"
        text << "|position=#{ occupation }%r"
        text << "|height=#{ height }%r"
        text << "|physique=#{ physique }%r"
        text << "|eyes=#{ eyes }%r"
        text << "|hair=#{ hair }%r"
        text << "]]"
        text << "%R%R"
        text << description
        text << "%R%R"
        text << background
        text << "%R%R"
        text << hooks
        text << "%R%R"
        text << goals

        text
      end
      
      def name
        @char.name
      end
      
      def fullname
        @char.fullname
      end
      
      def gender
        @char.gender
      end
      
      def height
        @char.height
      end
      
      def physique
        @char.physique
      end
      
      def hair
        @char.hair
      end
      
      def eyes
        @char.eyes
      end
      
      def age
        age = @char.age
        age == 0 ? "" : age
      end
      
      def actor
        @char.actor
      end
      
      def birthdate
        @char.birthdate.nil? ? "" : ICTime.ic_datestr(@char.birthdate)
      end

      def description
        "+ Description%R#{ @char.description }"
      end

      def faction
        @char.groups['Faction']
      end
      
      def position
        @char.groups['Position']
      end

      def occupation
        @char.groups['Occupation']
      end

      def colony
        @char.groups['Colony']
      end
      
      def department
        @char.groups['Department']
      end

      def rank
        @char.rank
      end
            
      def background
        "+ Background%R#{ @char.background } "
      end

      def hooks
        text = "+ RP Hooks"
        text << "%R"
        text << @char.hooks.map { |h, v| "%R* **#{h}** - #{v}" }.join
        text
      end

      def goals
        text = "+ Goals"
        text << "%R"
        text << @char.goals.map { |h, v| "%R* **#{h}** - #{v}" }.join
        text
      end

      def interests
        text = "+ Interests"
        text << "%R"
        text << @char.fs3_interests.map { |v| "%R* **#{v}**" }.join
        text
      end

      def expertise
        text = "+ Expertise"
        text << "%R"
        text << @char.fs3_expertise.map { |v| "%R* **#{v}**" }.join
        text
      end
    end
  end
end
