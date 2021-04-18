using Behavior
using Behavior.Gherkin
using Niancat.Languages

column(t::Gherkin.DataTable) = [row[1] for row in t]

@when("finding anagrams for {String}") do context, word
    dictionary = context[:dictionary]
    anagrams = findanagrams(dictionary, word)
    context[:anagrams] = anagrams
end

@when("seeing if {String} is in the dictionary") do context, word
    dictionary = context[:dictionary]
    context[:isindictionary] = word in dictionary
end

@then("these words are found") do context
    words = [lowercase(w) for w in column(context.datatable)]
    @expect sort(words) == sort(context[:anagrams])
end

@then("no words are found") do context
    @expect context[:anagrams] == []
end

@then("the answer is yes") do context
    @expect context[:isindictionary] == true
end

@then("the answer is no") do context
    @expect context[:isindictionary] == false
end