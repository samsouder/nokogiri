require File.expand_path(File.join(File.dirname(__FILE__), '..', "helper"))

module Nokogiri
  module XML
    class TestBuilder < Nokogiri::TestCase
      $the_global_var = 'one'
      @@the_class_var = 'two'
      @the_instance_var = 'three'

      def test_cdata
        the_local_var = 'hello world'
        builder = Nokogiri::XML::Builder.new do
          root {
            cdata the_local_var
            items {
              item $the_global_var
              item @@the_class_var
              item @the_instance_var
              item string_generation_method
            }
          }
        end
        assert_equal('<?xml version="1.0"?><root><![CDATA[hello world]]><items><item>one</item><item>two</item><item>three</item><item>four</item></items></root>', builder.to_xml.gsub(/\n/, ''))
      end

      def test_builder_no_block
        the_local_var = 'hello world'
        builder = Nokogiri::XML::Builder.new
        builder.root {
          cdata the_local_var
          items {
            item $the_global_var
            item @@the_class_var
            item @the_instance_var
            item string_generation_method
          }
        }
        assert_equal('<?xml version="1.0"?><root><![CDATA[hello world]]><items><item>one</item><item>two</item><item>three</item><item>four</item></items></root>', builder.to_xml.gsub(/\n/, ''))
      end

      private

      def string_generation_method
        "four"
      end
    end
  end
end
