Feature: Swedish Dictionary
    Note: This feature file really ought to be written in Swedish,
    but ExecutableSpecification does not (yet) support other languages.

    @wip
    Scenario Outline: Non-meaningful diacritics
        Given that the word <word> is in the Swedish dictionary
         When a look-up of the word with spelling <no diacritics> is made
         Then it is found in the dictionary
    
        Examples:
            | word      | no diacritics |
            | TÊTEÀTÊTE | TETEATETE     |
            | MÜSLI     | MUSLI         |

    @wip
    Scenario Outline: Meaningful diacritics
        Given that the word <word> is in the Swedish dictionary
         When a look-up of the word with spelling <alternative> is made
         Then it is not found in the dictionary
    
        Examples:
            | word      | alternative |
            | Å         | A           |
            | ÄR        | AR          |
            | Ö         | O           |
    
    Scenario Outline: Case-insensitivity
        Given that the word <word> is in the Swedish dictionary
         When a look-up of the word with spelling <alternative> is made
         Then it is found in the dictionary
        
        Examples:
            | word      | alternative |
            | PUSSGURKA | pussgurka   |
            | PUSSGURKA | PussGurka   |
            | pussgurka | PUSSGURKA   |
            | PussGurka | PUSSGURKA   |
            | Å         | å           |
            | ÄR        | är          |
            | Ö         | ö           |