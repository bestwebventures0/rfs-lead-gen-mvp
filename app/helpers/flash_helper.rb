module FlashHelper
    def classes_for_flash(key)
        case key.to_sym
        when :notice
            "bg-blue-100 text-blue-700"
        when :alert
            "bg-red-100 text-red-700"
        else
            "bg-gray-100 text-gray-700"
        end
    end
end
