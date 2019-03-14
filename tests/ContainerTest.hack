use namespace Nazg\Glue\Exception;
use type Nazg\Glue\Container;
use type Nazg\Glue\Scope;
use type Nazg\Glue\ProviderInterface;
use type Facebook\HackTest\HackTest;
use function Facebook\FBExpect\expect;

final class ContainerTest extends HackTest {

  public function testShoulbReturnPrototypeInstance(): void {
    $container = new Container();
    $container->bind(Mock::class)
      ->to(Mock::class, Scope::PROTOTYPE);
    $container->lock();
    expect($container->get(Mock::class))
      ->toNotBeSame($container->get(Mock::class));
  }

  public function testShoulbReturnSingletonInstance(): void {
    $container = new Container();
    $container->bind(Mock::class)
      ->to(Mock::class);
    $container->lock();
    expect($container->get(Mock::class))
      ->toBeSame($container->get(Mock::class));
  }

  public function testShoulbThrowNotBindingExceptionAtComplexPrototypeInstance(): void {
    $container = new Container();
    $container->bind(AnyInterface::class)
      ->to(Any::class, Scope::PROTOTYPE);
    $container->lock();
    expect(() ==> $container->get(AnyInterface::class))
      ->toThrow(Exception\NotFoundException::class);
  }

  public function testShoulbReturnComplexPrototypeInstance(): void {
    $container = new Container();
    $container->bind(AnyInterface::class)
      ->to(Any::class, Scope::PROTOTYPE);
    $container->bind(Mock::class)
      ->to(Mock::class, Scope::PROTOTYPE);
    $container->lock();
    expect($container->get(AnyInterface::class))
      ->toBeInstanceOf(AnyInterface::class);
  }

  public function testShoulbReturnComplexPrototypeInstanceByProvider(): void {
    $container = new Container();
    $container->bind(AnyInterface::class)
      ->to(Any::class, Scope::PROTOTYPE);
    $container->bind(Mock::class)
      ->to(Mock::class, Scope::PROTOTYPE);
    $container->bind(ProviderInterface::class)
      ->provider(AnyProvider::class);
    $container->lock();
    expect($container->get(AnyInterface::class))
      ->toBeInstanceOf(AnyInterface::class);
  }
}

final class Mock {

}

interface AnyInterface {

}

final class Any implements AnyInterface {
  public function __construct(private Mock $mock) {

  }
}

final class AnyProvider implements ProviderInterface {

  public function get(
    \Nazg\Glue\Container $container
  ): Any {
    return $container->get(Any::class);
  }
}
