# Details in the {introduction article}[http://roman.flucti.com/painless-record-creation-with-activerecord].
module TestUnitExt::EasyRecordInsertion
  # Usage examples:
  #
  #   insert! Host, :ip_address => '192.168.0.1'
  #   insert! Host, {:hostname => 'foo'}, :trigger_validation => true
  #   insert! Host, {}, :inhibit_callbacks => false
  #
  def insert!(model, attributes={}, options={})
    attributes          = attributes.stringify_keys
    trigger_validation  = options.fetch(:trigger_validation, false)
    inhibit_callbacks   = options.fetch(:inhibit_callbacks, !trigger_validation)
    begin
      record = model.new { |record| record.send(:attributes=, attributes, false) }
      if inhibit_callbacks
        def record.callback(*args)
        end
      end
      if trigger_validation
        record.valid?
      end
      record.save(false)
    rescue ActiveRecord::StatementInvalid
      if $!.message =~ /Column '(.+?)' cannot be null/
        unless attributes.key?($1)
          attributes[$1] = record.column_for_attribute($1).number? ? 0 : "-"
          retry
        end
      end
      raise
    end
    return record
  end
end
