using ExecutableSpecifications
using Niancat.Languages

@given("that the word {String} is in the Swedish dictionary") do context, word
    context[:dictionary] = SwedishDictionary([word])
end

@when("a look-up of the word with spelling {String} is made") do context, word
    dictionary = context[:dictionary]
    context[:isindictionary]= word in dictionary
end

@then("it is found in the dictionary") do context
    isindictionary = context[:isindictionary]
    @expect isindictionary == true
end

@then("it is not found in the dictionary") do context
    isindictionary = context[:isindictionary]
    @expect isindictionary == false
end