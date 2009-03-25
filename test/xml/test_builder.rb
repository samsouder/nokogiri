require File.expand_path(File.join(File.dirname(__FILE__), '..', "helper"))

module Nokogiri
  module XML
    class TestBuilder < Nokogiri::TestCase
      def test_nested_variables
        @ivar  = 'instance'
        localvar = 'local'
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.root do
            xml.foo localvar
            xml.bar @ivar
            xml.baz {
              xml.text @ivar
            }
          end
        end

        assert_equal 'local', builder.doc.at('//root/foo').content
        assert_equal 'instance', builder.doc.at('//root/bar').content
        assert_equal 'instance', builder.doc.at('baz').content
      end

      def test_cdata
        localvar = 'local'
        builder = Nokogiri::XML::Builder.new do
          root {
            cdata localvar
          }
        end

        assert_equal('<?xml version="1.0"?><root><![CDATA[local]]></root>', builder.to_xml.gsub(/\n/, ''))
      end

      def test_builder_no_block
        localvar = 'local'
        builder = Nokogiri::XML::Builder.new
        builder.root {
          cdata localvar
        }

        assert_equal('<?xml version="1.0"?><root><![CDATA[local]]></root>', builder.to_xml.gsub(/\n/, ''))
      end

      def test_string_method_no_block
        builder = Nokogiri::XML::Builder.new
        builder.root {
            foo string_generation_method
        }

        assert_equal 'string_generation', builder.doc.at('//root/foo').content
      end

      def test_string_method
        builder = Nokogiri::XML::Builder.new do
          root {
            foo string_generation_method
          }
        end

        assert_equal 'string_generation', builder.doc.at('//root/foo').content
      end

      def string_generation_method
        "string generation"
      end
    end
  end
end
