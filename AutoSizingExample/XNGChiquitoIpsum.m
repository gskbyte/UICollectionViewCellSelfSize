#import "XNGChiquitoIpsum.h"

@interface XNGChiquitoIpsum ()

@end

@implementation XNGChiquitoIpsum

+ (NSArray*)words {
    static NSArray * words;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * text = @"Lorem fistrum pecador qué dise usteer torpedo la caidita mamaar amatomaa va usté muy cargadoo. A gramenawer por la gloria de mi madre quietooor ahorarr caballo blanco caballo negroorl a wan pupita ese que llega mamaar hasta luego Lucas benemeritaar. Amatomaa a peich no puedor te va a hasé pupitaa se calle ustée pecador a gramenawer por la gloria de mi madre no te digo trigo por no llamarte Rodrigor por la gloria de mi madre amatomaa. Apetecan jarl al ataquerl benemeritaar benemeritaar papaar papaar te voy a borrar el cerito te va a hasé pupitaa apetecan. Tiene musho peligro te va a hasé pupitaa ese hombree te va a hasé pupitaa qué dise usteer. De la pradera está la cosa muy malar se calle ustée torpedo papaar papaar tiene musho peligro sexuarl. A gramenawer no puedor a wan te va a hasé pupitaa. Fistro benemeritaar ese hombree ese hombree apetecan sexuarl condemor ese que llega ese pedazo de de la pradera hasta luego Lucas. Apetecan diodeno fistro va usté muy cargadoo ese hombree pupita ese que llega pupita se calle ustée. Tiene musho peligro sexuarl caballo blanco caballo negroorl diodenoo. Llevame al sircoo te va a hasé pupitaa te voy a borrar el cerito benemeritaar a peich pecador no te digo trigo por no llamarte Rodrigor está la cosa muy malar ese que llega no te digo trigo por no llamarte Rodrigor. Diodeno hasta luego Lucas a wan hasta luego Lucas tiene musho peligro caballo blanco caballo negroorl pecador. Ese hombree pupita quietooor diodenoo sexuarl pecador.";
        words = [text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    });
    return words;
}

+ (NSString*) stringWithWordCountSinceBeginning:(NSUInteger)wordCount {
    NSArray *subarray = [self.class.words subarrayWithRange:NSMakeRange(0, wordCount)];
    return [subarray componentsJoinedByString:@" "];
}

+ (NSString *)stringWithWordCount:(NSUInteger)wordCount {
    NSUInteger begin = arc4random_uniform((u_int32_t)(self.class.words.count-wordCount));
    NSArray *subarray = [self.class.words subarrayWithRange:NSMakeRange(begin, wordCount)];
    return [subarray componentsJoinedByString:@" "];
}

+ (NSString *)stringWithWordCountBetween:(NSUInteger)min and:(NSUInteger)max {
    NSUInteger wordCount = min + arc4random_uniform((u_int32_t)(max-min));
    return [self.class stringWithWordCount:wordCount];
}

@end
