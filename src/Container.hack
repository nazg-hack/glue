namespace Nazg\Glue;

use namespace Nazg\Glue\Exception;
use namespace Nazg\Glue\Serializer;
use namespace HH\Lib\{C, Str};

class Container {

  private dict<string, (DependencyInterface, Scope)> $bindings = dict[];
  private bool $isLock = false;

  public function __construct(
    private ?ContainerCache $cache = null
  ) {}

  public function bind<T>(
    typename<T> $id
  ): Bind<T> {
    return new Bind($this, $id);
  }

  public function add<T>(Bind<T> $bind): void {
    if($this->isLock === false) {
      $bound = $bind->getBound();
      if($bound is DependencyInterface) {
        $this->bindings[$bind->getId()] = tuple($bound, $bind->getScope());
      }
    }
  }

  protected function resolve<T>(typename<T> $id): T {
    if ($this->has($id)) {
      list($bound, $scope) = $this->bindings[$id];
      if ($bound is DependencyInterface) {
        return $bound->resolve($this, $scope);
      }
    }
    throw new Exception\NotFoundException(
      Str\format('Identifier "%s" is not binding.', $id),
    );
  }

  public function get<T>(typename<T> $t): T {
    return $this->resolve($t);
  }


  public async function lockAsync(): Awaitable<void> {
    $this->isLock = true;
    if ($this->cache is ContainerCache) {
      await $this->cache->serializeAsync($this->getBindings());
    }
  }

  <<__Memoize>>
  protected function resolveBindings(): dict<string, (DependencyInterface, Scope)> {
    if ($this->cache is ContainerCache) {
      return \HH\Asio\join($this->cache->unserializeAsync());
    }
    return dict[];
  }

  public function has<T>(typename<T> $id): bool {
    if ($this->isLock === true) {
      if ($this->cache is ContainerCache) {
        $this->bindings = $this->resolveBindings();
      }
    }
    return C\contains_key($this->bindings, $id);
  }

  public function registerModule(
    classname<ServiceModule> $moduleClassName
  ): void {
    new $moduleClassName()
    |> $$->provide($this);
  }

  <<__Rx>>
  public function getBindings(): dict<string, (DependencyInterface, Scope)> {
    return $this->bindings;
  }
}
