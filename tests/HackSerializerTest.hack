use type Nazg\Glue\Scope;
use type Nazg\Glue\Container;
use type Nazg\Glue\FileCache;
use type Nazg\Glue\ProviderInterface;
use type Nazg\Glue\DependencyProvider;
use type Nazg\Glue\Serializer\HackSerializer;
use type Nazg\Glue\Serializer\HackUnserializer;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class HackSerializerTest extends HackTest {

  public function testShouldDictSerialize(): void {
    $serializer = new HackSerializer(dict[
      'HackSerializerStdClassProvider' => tuple(
        new DependencyProvider(new HackSerializerStdClassProvider()), 
        Scope::SINGLETON
      )
    ]);
    expect($serializer->serialize())
      ->toNotBeEmpty();
  }
}

final class HackSerializerStdClassProvider implements ProviderInterface<\stdClass> {

  public function get(\Nazg\Glue\Container $container): \stdClass {
    return new \stdClass();
  }
}
