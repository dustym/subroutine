# frozen_string_literal: true

require "test_helper"
require "subroutine/fields"

module Subroutine
  class FieldsTest < TestCase

    class Whatever

      include Subroutine::Fields

      string :foo, default: "foo"
      integer :bar, default: -> { 3 }
      date :baz

      def initialize(options = {})
        setup_fields(options)
      end

    end

    def test_fields_are_configured
      assert_equal 3, Whatever._fields.size
      assert_equal :string, Whatever._fields[:foo][:type]
      assert_equal :integer, Whatever._fields[:bar][:type]
      assert_equal :date, Whatever._fields[:baz][:type]
    end

    def test_field_defaults_are_handled
      instance = Whatever.new
      assert_equal "foo", instance.foo
      assert_equal 3, instance.bar
    end

    def test_fields_can_be_provided
      instance = Whatever.new(foo: "abc", bar: nil)
      assert_equal "abc", instance.foo
      assert_nil instance.bar
    end

    def test_field_provided
      instance = Whatever.new(foo: "abc")
      assert_equal true, instance.field_provided?(:foo)
      assert_equal false, instance.field_provided?(:bar)
    end

    def test_field_provided

      instance = Whatever.new(foo: "abc")
      assert_equal true, instance.field_provided?(:foo)
      assert_equal false, instance.field_provided?(:bar)

      instance = DefaultsOp.new
      assert_equal false, instance.field_provided?(:foo)

      instance = DefaultsOp.new(foo: 'foo')
      assert_equal true, instance.field_provided?(:foo)
    end

    def test_invalid_typecast
      assert_raises "Error for field `baz`: invalid date" do
        Whatever.new(baz: "2015-13-01")
      end
    end

    def test_params
      instance = Whatever.new(foo: "abc")
      assert_equal({ "foo" => "abc" }, instance.params)
      assert_equal({ "foo" => "abc", "bar" => 3 }, instance.params_with_defaults)
      assert_equal({ "foo" => "foo", "bar" => 3 }, instance.defaults)
    end

  end
end
