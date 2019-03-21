use type Nazg\Glue\ContainerBuilder;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class ContainerBuilderTest extends HackTest {

  const string FILENAME = __DIR__ . '/resources/stub.cache';

  public function testShouldReturnContainerInstance(): void {
    $builder = new ContainerBuilder();
    $container = $builder->make();
    expect($container)
      ->toBeInstanceOf(\Nazg\Glue\Container::class);
    expect($container)
      ->toNotBeInstanceOf(\Nazg\Glue\CachedContainer::class);
  }

  public function testShouldReturnCachedContainerInstance(): void {
    $builder = new ContainerBuilder(true, self::FILENAME);
    $container = $builder->make();
    expect($container)
      ->toBeInstanceOf(\Nazg\Glue\Container::class);
    expect($container)
      ->toBeInstanceOf(\Nazg\Glue\CachedContainer::class);
  }
}
