class String
    def titlecase
      gsub(/(?:_|\b)(.)/){$1.upcase}
    end
  end