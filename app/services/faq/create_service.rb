module FaqModule
  class CreateService
    def initialize(params)
      # TODO: identify origin and set company
      @company = Company.last
      @question = params["question-original"]
      @answer = params["answer-original"]
      @hashtags = params["hashtags-original"]
    end

    def call
      return @company.id.to_s + "question:" + @question + "answer:" + @answer + "hashtags:" + @hashtags
      return 'Hashtag Obrigatória' if @hashtags == nil
      Faq.transaction do
        faq = Faq.create(question: @question, answer: @answer, company: @company)
        return "Hashtag Obrigatória" if @hashtags == nil
        @hashtags.split(/[\s,]+/).each do |hashtag|
          faq.hashtags << Hashtag.create(name: hashtag)
        end
      end
      "Criado com sucesso. Total de perguntas #{Faq.count}"
    end
  end
end