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
      ->to(Mock::class)
      ->in(Scope::PROTOTYPE);
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
      ->to(Any::class)
      ->in(Scope::PROTOTYPE);
    $container->lock();
    expect(() ==> $container->get(AnyInterface::class))
      ->toThrow(Exception\NotFoundException::class);
  }

  public function testShoulbReturnComplexPrototypeInstance(): void {
    $container = new Container();
    $container->bind(AnyInterface::class)
      ->to(Any::class)
      ->in(Scope::PROTOTYPE);
    $container->bind(Mock::class)
      ->to(Mock::class)
      ->in(Scope::PROTOTYPE);
    $container->lock();
    expect($container->get(AnyInterface::class))
      ->toBeInstanceOf(AnyInterface::class);
  }

  public function testShoulbReturnComplexPrototypeInstanceByProvider(): void {
    $container = new Container();
    $container->bind(Mock::class)
      ->to(Mock::class)
      ->in(Scope::PROTOTYPE);
    $container->bind(Any::class)
      ->provider(new AnyProvider($container));
    $container->lock();
    expect($container->get(Any::class))
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

final class AnyProvider implements ProviderInterface<Any> {

  public function __construct(
    private \Nazg\Glue\Container $container
  ) {}

  public function get(): Any {
    return new Any($this->container->get(Mock::class));
  }
}
